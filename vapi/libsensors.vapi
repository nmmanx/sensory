/*
 * Copyright (C) 2022 Man Nguyen <nmman37@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
[CCode (cheader_filename = "sensors/sensors.h,sensors/error.h")]
namespace Sensors {
    public const uint API_VERSION;

    [CCode (cname = "int", cprefix = "SENSORS_BUS_TYPE_", has_type_id = false)]
    public enum BusType {
        I2C,
        ISA,
        PCI,
        SPI,
        VIRTUAL,
        ACPI,
        HID,
        MDIO,
        SCSI
    }

    [CCode (cname = "libsensors_version", has_type_id = false)]
    public const string version;
}