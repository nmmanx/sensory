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

    public const uint ERR_WILDCARDS;   /* Wildcard found in chip name */
    public const uint ERR_NO_ENTRY;	   /* No such subfeature known */
    public const uint ERR_ACCESS_R;    /* Can't read */
    public const uint ERR_KERNEL;      /* Kernel interface error */
    public const uint ERR_DIV_ZERO;	   /* Divide by zero */
    public const uint ERR_CHIP_NAME;   /* Can't parse chip name */
    public const uint ERR_BUS_NAME;    /* Can't parse bus name */
    public const uint ERR_PARSE;       /* General parse error */
    public const uint ERR_ACCESS_W;    /* Can't write */
    public const uint ERR_IO;          /* I/O error */
    public const uint ERR_RECURSION;   /* Evaluation recurses too deep */

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

    [CCode (cname = "sensors_bus_id", has_type_id = false)]
    public struct BusId {
        short type;
        short nr;
    }

    [CCode (cname = "sensors_chip_name", has_type_id = false)]
    public struct ChipName {
        string prefix;
        BusId bus;
        int addr;
        string path;
    }

    [CCode (cname = "sensors_feature_type", cprefix = "SENSORS_FEATURE_", has_type_id = false)]
    public enum FeatureType {
        IN,
        FAN,
        TEMP,
        POWER,
        ENERGY,
        CURR,
        HUMIDITY,
        MAX_MAIN,
        VID,
        INTRUSION,
        MAX_OTHER,
        BEEP_ENABLE,
        MAX,
        UNKNOWN
    }

    [CCode (cname = "sensors_subfeature_type", cprefix = "SENSORS_SUBFEATURE_", has_type_id = false)]
    [Flags]
    public enum SubFeatureType {
        IN_INPUT,
        IN_MIN,
        IN_MAX,
        IN_LCRIT,
        IN_CRIT,
        IN_AVERAGE,
        IN_LOWEST,
        IN_HIGHEST,
        IN_ALARM,
        IN_MIN_ALARM,
        IN_MAX_ALARM,
        IN_BEEP,
        IN_LCRIT_ALARM,
        IN_CRIT_ALARM,

        FAN_INPUT,
        FAN_MIN,
        FAN_MAX,
        FAN_ALARM,
        FAN_FAULT,
        FAN_DIV,
        FAN_BEEP,
        FAN_PULSES,
        FAN_MIN_ALARM,
        FAN_MAX_ALARM,

        TEMP_INPUT,
        TEMP_MAX,
        TEMP_MAX_HYST,
        TEMP_MIN,
        TEMP_CRIT,
        TEMP_CRIT_HYST,
        TEMP_LCRIT,
        TEMP_EMERGENCY,
        TEMP_EMERGENCY_HYST,
        TEMP_LOWEST,
        TEMP_HIGHEST,
        TEMP_MIN_HYST,
        TEMP_LCRIT_HYST,
        TEMP_ALARM,
        TEMP_MAX_ALARM,
        TEMP_MIN_ALARM,
        TEMP_CRIT_ALARM,
        TEMP_FAULT,
        TEMP_TYPE,
        TEMP_OFFSET,
        TEMP_BEEP,
        TEMP_EMERGENCY_ALARM,
        TEMP_LCRIT_ALARM,
    
        POWER_AVERAGE,
        POWER_AVERAGE_HIGHEST,
        POWER_AVERAGE_LOWEST,
        POWER_INPUT,
        POWER_INPUT_HIGHEST,
        POWER_INPUT_LOWEST,
        POWER_CAP,
        POWER_CAP_HYST,
        POWER_MAX,
        POWER_CRIT,
        POWER_MIN,
        POWER_LCRIT,
        POWER_AVERAGE_INTERVAL,
        POWER_ALARM,
        POWER_CAP_ALARM,
        POWER_MAX_ALARM,
        POWER_CRIT_ALARM,
        POWER_MIN_ALARM,
        POWER_LCRIT_ALARM,
    
        ENERGY_INPUT,
    
        CURR_INPUT,
        CURR_MIN,
        CURR_MAX,
        CURR_LCRIT,
        CURR_CRIT,
        CURR_AVERAGE,
        CURR_LOWEST,
        CURR_HIGHEST,
        CURR_ALARM,
        CURR_MIN_ALARM,
        CURR_MAX_ALARM,
        CURR_BEEP,
        CURR_LCRIT_ALARM,
        CURR_CRIT_ALARM,
    
        HUMIDITY_INPUT,
    
        VID,
    
        INTRUSION_ALARM,
        INTRUSION_BEEP,
    
        BEEP_ENABLE,
    
        UNKNOWN,
    }

    [CCode (cname = "sensors_feature", has_type_id = false)]
    public struct Feature {
        string name;
        int number;
        FeatureType type;
        int first_subfeature;
        int padding1;
    }

    [CCode (cname = "sensors_subfeature", has_type_id = false)]
    public struct SubFeature {
        string name;
        int number;
        SubFeatureType type;
        int mapping;
        uint flags;
    }
}