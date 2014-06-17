/*
 * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies)
 * Copyright (C) 2011 Collabora Ltd.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
 */
#ifndef DeviceMotionClientGtk_h
#define DeviceMotionClientGtk_h

#include "DeviceMotionClient.h"
#include "DeviceMotionData.h"

namespace WebKit {

class DeviceMotionClientGtk : public WebCore::DeviceMotionClient {
public:
    DeviceMotionClientGtk();
    virtual ~DeviceMotionClientGtk();

    virtual void setController(WebCore::DeviceMotionController*);
    virtual void startUpdating();
    virtual void stopUpdating();
    virtual WebCore::DeviceMotionData* lastMotion() const;
    virtual void deviceMotionControllerDestroyed();

private:
    WebCore::DeviceMotionController* m_controller;
};

} // namespece WebKit

#endif // DeviceMotionClientGtk_h
