/*
 * Copyright (C) 2022  Man Nguyen <nmman37@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
[CCode (cheader_filename = "sensors/sensors.h,sensors/error.h")]
namespace Sensors {
    public const uint API_VERSION;

    public const int ERR_WILDCARDS;   /* Wildcard found in chip name */
    public const int ERR_NO_ENTRY;	  /* No such subfeature known */
    public const int ERR_ACCESS_R;    /* Can't read */
    public const int ERR_KERNEL;      /* Kernel interface error */
    public const int ERR_DIV_ZERO;	  /* Divide by zero */
    public const int ERR_CHIP_NAME;   /* Can't parse chip name */
    public const int ERR_BUS_NAME;    /* Can't parse bus name */
    public const int ERR_PARSE;       /* General parse error */
    public const int ERR_ACCESS_W;    /* Can't write */
    public const int ERR_IO;          /* I/O error */
    public const int ERR_RECURSION;   /* Evaluation recurses too deep */

    [CCode (cname = "sensors_strerror")]
    public unowned string strerror (int errnum);

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

    [CCode (cname = "sensors_init")]
    public int init (GLib.FileStream? input);

    [CCode (cname = "sensors_cleanup")]
    public int cleanup ();

    [CCode (cname = "sensors_parse_chip_name")]
    public int parse_chip_name (string orig_name, out Sensors.ChipName res);

    [CCode (cname = "sensors_free_chip_name")]
    public int free_chip_name (Sensors.ChipName chip);

    [CCode (cname = "sensors_snprintf_chip_name")]
    public int snprintf_chip_name (string str, size_t size, Sensors.ChipName chip);

    [CCode (cname = "sensors_get_adapter_name")]
    public unowned string? get_adapter_name (Sensors.BusId bus);

    [CCode (cname = "sensors_get_label")]
    public unowned string? get_label (Sensors.ChipName name, Sensors.Feature feature);

    [CCode (cname = "sensors_get_value")]
    public int get_value (Sensors.ChipName name, int subfeat_nr, out double value);

    [CCode (cname = "sensors_set_value")]
    public int set_value (Sensors.ChipName name, int subfeat_nr, double value);

    [CCode (cname = "sensors_do_chip_sets")]
    public int do_chip_sets (Sensors.ChipName name);

    [CCode (cname = "sensors_get_detected_chips")]
    public unowned Sensors.ChipName? get_detected_chips (Sensors.ChipName? match, ref int nr);

    [CCode (cname = "sensors_get_features")]
    public unowned Sensors.Feature? get_features (Sensors.ChipName name, ref int nr);

    [CCode (cname = "sensors_get_all_subfeatures")]
    public unowned Sensors.SubFeature? get_all_subfeatures (Sensors.ChipName name, Sensors.Feature feature, ref int nr);

    [CCode (cname = "sensors_get_subfeature")]
    public unowned Sensors.SubFeature? get_subfeature (Sensors.ChipName name, Sensors.Feature feature, ref int nr);
}