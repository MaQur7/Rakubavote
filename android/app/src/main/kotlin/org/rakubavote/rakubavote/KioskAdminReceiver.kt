package org.rakubavote.rakubavote

import android.app.admin.DeviceAdminReceiver

/** Device admin used only to allow lock-task (kiosk) mode for this app. */
class KioskAdminReceiver : DeviceAdminReceiver()
