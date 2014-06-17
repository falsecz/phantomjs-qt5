/****************************************************************************
**
** Copyright (C) 2012 BogDan Vatra <bogdan@kde.org>
** Contact: http://www.qt-project.org/legal
**
** This file is part of the plugins of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qandroidassetsfileenginehandler.h"
#include "androidjnimain.h"

#include <QCoreApplication>
#include <QVector>

typedef QVector<QString> FilesList;

struct AndroidAssetDir
{
    AndroidAssetDir(AAssetDir* ad)
    {
        const char *fileName;
        while ((fileName = AAssetDir_getNextFileName(ad)))
            m_items.push_back(QString::fromUtf8(fileName));
        AAssetDir_close(ad);
    }
    FilesList m_items;
};

class AndroidAbstractFileEngineIterator: public QAbstractFileEngineIterator
{
public:
    AndroidAbstractFileEngineIterator(QDir::Filters filters,
                                      const QStringList &nameFilters,
                                      QSharedPointer<AndroidAssetDir> asset,
                                      const QString &path)
        : QAbstractFileEngineIterator(filters, nameFilters)
    {
        m_items = asset->m_items;
        m_index = -1;
        m_path = path;
    }

    virtual QFileInfo currentFileInfo() const
    {
        return QFileInfo(currentFilePath());
    }

    virtual QString currentFileName() const
    {
        if (m_index < 0 || m_index >= m_items.size())
            return QString();
        return m_items[m_index];
    }

    virtual QString currentFilePath() const
    {
        return m_path + currentFileName();
    }

    virtual bool hasNext() const
    {
        return m_items.size() && (m_index < m_items.size() - 1);
    }

    virtual QString next()
    {
        if (!hasNext())
            return QString();
        m_index++;
        return currentFileName();
    }

private:
    QString     m_path;
    FilesList   m_items;
    int         m_index;
};

class AndroidAbstractFileEngine: public QAbstractFileEngine
{
public:
    explicit AndroidAbstractFileEngine(AAsset *asset, const QString &fileName)
    {
        m_assetFile = asset;
        m_fileName = fileName;
    }

    explicit AndroidAbstractFileEngine(QSharedPointer<AndroidAssetDir> asset, const QString &fileName)
    {
        m_assetFile = 0;
        m_assetDir = asset;
        m_fileName =  fileName;
        if (!m_fileName.endsWith(QChar(QLatin1Char('/'))))
            m_fileName += "/";
    }

    ~AndroidAbstractFileEngine()
    {
        close();
    }

    virtual bool open(QIODevice::OpenMode openMode)
    {
        if (m_assetFile)
            return openMode & QIODevice::ReadOnly;
        return false;
    }

    virtual bool close()
    {
        if (m_assetFile) {
            AAsset_close(m_assetFile);
            m_assetFile = 0;
            return true;
        }
        return false;
    }

    virtual qint64 size() const
    {
        if (m_assetFile)
            return AAsset_getLength(m_assetFile);
        return -1;
    }

    virtual qint64 pos() const
    {
        if (m_assetFile)
            return AAsset_seek(m_assetFile, 0, SEEK_CUR);
        return -1;
    }

    virtual bool seek(qint64 pos)
    {
        if (m_assetFile)
            return pos == AAsset_seek(m_assetFile, pos, SEEK_SET);
        return false;
    }

    virtual qint64 read(char *data, qint64 maxlen)
    {
        if (m_assetFile)
            return AAsset_read(m_assetFile, data, maxlen);
        return -1;
    }

    virtual bool isSequential() const
    {
        return false;
    }

    virtual bool caseSensitive() const
    {
        return true;
    }

    virtual bool isRelativePath() const
    {
        return false;
    }

    virtual FileFlags fileFlags(FileFlags type = FileInfoAll) const
    {
        FileFlags flags(ReadOwnerPerm|ReadUserPerm|ReadGroupPerm|ReadOtherPerm|ExistsFlag);
        if (m_assetFile)
            flags |= FileType;
        if (!m_assetDir.isNull())
            flags |= DirectoryType;

        return type & flags;
    }

    virtual QString fileName(FileName file = DefaultName) const
    {
        int pos;
        switch (file) {
        case DefaultName:
        case AbsoluteName:
        case CanonicalName:
                return m_fileName;
        case BaseName:
            if ((pos = m_fileName.lastIndexOf(QChar(QLatin1Char('/')))) != -1)
                return m_fileName.mid(pos);
            else
                return m_fileName;
        case PathName:
        case AbsolutePathName:
        case CanonicalPathName:
            if ((pos = m_fileName.lastIndexOf(QChar(QLatin1Char('/')))) != -1)
                return m_fileName.left(pos);
            else
                return m_fileName;
        default:
            return QString();
        }
    }

    virtual void setFileName(const QString &file)
    {
        if (file == m_fileName)
            return;

        m_fileName = file;
        if (!m_fileName.endsWith(QChar(QLatin1Char('/'))))
            m_fileName += "/";

        close();
    }

    virtual Iterator *beginEntryList(QDir::Filters filters, const QStringList &filterNames)
    {
        if (!m_assetDir.isNull())
            return new AndroidAbstractFileEngineIterator(filters, filterNames, m_assetDir, m_fileName);
        return 0;
    }

private:
    AAsset *m_assetFile;
    QSharedPointer<AndroidAssetDir> m_assetDir;
    QString m_fileName;
};


AndroidAssetsFileEngineHandler::AndroidAssetsFileEngineHandler():m_assetsCache(std::max(5, qgetenv("QT_ANDROID_MAX_ASSETS_CACHE_SIZE").toInt()))
{
    m_assetManager = QtAndroid::assetManager();
}

AndroidAssetsFileEngineHandler::~AndroidAssetsFileEngineHandler()
{
}

QAbstractFileEngine * AndroidAssetsFileEngineHandler::create(const QString &fileName) const
{
    if (fileName.isEmpty())
        return 0;

    if (!fileName.startsWith(QLatin1String("assets:/")))
        return 0;

    int prefixSize=8;

    QByteArray path;
    if (!fileName.endsWith(QLatin1Char('/'))) {
        path = fileName.toUtf8();
        AAsset *asset = AAssetManager_open(m_assetManager,
                                           path.constData() + prefixSize,
                                           AASSET_MODE_BUFFER);
        if (asset)
            return new AndroidAbstractFileEngine(asset, fileName);
    }

    if (!path.size())
         path = fileName.left(fileName.length() - 1).toUtf8();

    m_assetsCacheMutext.lock();
    QSharedPointer<AndroidAssetDir> *aad = m_assetsCache.object(path);
    m_assetsCacheMutext.unlock();
    if (!aad) {
        AAssetDir *assetDir = AAssetManager_openDir(m_assetManager, path.constData() + prefixSize);
        if (assetDir) {
            if (AAssetDir_getNextFileName(assetDir)) {
                AAssetDir_rewind(assetDir);
                aad = new QSharedPointer<AndroidAssetDir>(new AndroidAssetDir(assetDir));
                m_assetsCacheMutext.lock();
                m_assetsCache.insert(path, aad);
                m_assetsCacheMutext.unlock();
                return new AndroidAbstractFileEngine(*aad, fileName);
            } else {
                AAssetDir_close(assetDir);
            }
        }
    } else {
        return new AndroidAbstractFileEngine(*aad, fileName);
    }
    return 0;
}
