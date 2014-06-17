/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the plugins of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "phantomintegration.h"
#include "phantombackingstore.h"

#include <private/qpixmap_raster_p.h>

#if defined(Q_OS_MAC)
# include <QtPlatformSupport/private/qcoretextfontdatabase_p.h>
#elif defined(Q_OS_WIN)
# include "qwindowsfontdatabase.h"
#else
# include <private/qfontconfigdatabase_p.h>
#endif

#if !defined(Q_OS_WIN)
#include <QtPlatformSupport/private/qgenericunixeventdispatcher_p.h>
#elif defined(Q_OS_WINRT)
#include <QtCore/private/qeventdispatcher_winrt_p.h>
#else
#include <QtCore/private/qeventdispatcher_win_p.h>
#endif

PhantomIntegration::PhantomIntegration()
{
    PhantomScreen *mPrimaryScreen = new PhantomScreen();

    // Simulate typical desktop screen
    int width = 1024;
    int height = 768;
    int dpi = 72;
    qreal physicalWidth = width * 25.4 / dpi;
    qreal physicalHeight = height * 25.4 / dpi;
    mPrimaryScreen->mGeometry = QRect(0, 0, width, height);
    mPrimaryScreen->mPhysicalSize = QSizeF(physicalWidth, physicalHeight);

    mPrimaryScreen->mDepth = 32;
    mPrimaryScreen->mFormat = QImage::Format_ARGB32_Premultiplied;

    screenAdded(mPrimaryScreen);
}

bool PhantomIntegration::hasCapability(QPlatformIntegration::Capability cap) const
{
    switch (cap) {
    case ThreadedPixmaps: return true;
    default: return QPlatformIntegration::hasCapability(cap);
    }
}

QPlatformWindow* PhantomIntegration::createPlatformWindow(QWindow* window) const
{
    return new QPlatformWindow(window);
}

QPlatformBackingStore* PhantomIntegration::createPlatformBackingStore(QWindow* window) const
{
    return new PhantomBackingStore(window);
}

QPlatformFontDatabase *PhantomIntegration::fontDatabase() const
{
    static QPlatformFontDatabase *db = 0;
    if (!db) {
#if defined(Q_OS_MAC)
        db = new QCoreTextFontDatabase();
#elif defined(Q_OS_WIN)
        db = new QWindowsFontDatabase();
#else
        db = new QFontconfigDatabase();
#endif
    }
    return db;
}

QAbstractEventDispatcher *PhantomIntegration::createEventDispatcher() const
{
#ifdef Q_OS_WIN
#ifndef Q_OS_WINRT
    return new QEventDispatcherWin32;
#else // !Q_OS_WINRT
    return new QEventDispatcherWinRT;
#endif // Q_OS_WINRT
#else
    return createUnixEventDispatcher();
#endif
}
