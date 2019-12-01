// UtilsString.js
// Version 0.5
.pragma library

/* ************************************************************************** */

/*!
 * padNumberInternal()
 * Only used for duration whithin this file.
 */
function padNumberInternal(n) {
    n = n + '';
    return n.length >= 2 ? n : new Array(2 - n.length + 1).join('0') + n;
}

/*!
 * durationToString_long()
 * Format is 'XX hours XX min XX sec XX ms'
 */
function durationToString_long(duration) {
    var text = '';

    if (duration <= 0) return qsTr("Unknown duration");

    var hours = Math.floor(duration / 3600000);
    var minutes = Math.floor((duration - (hours * 3600000)) / 60000);
    var seconds = Math.floor((duration - (hours * 3600000) - (minutes * 60000)) / 1000);
    var ms = (duration - (hours * 3600000) - (minutes * 60000)) - (seconds * 1000);

    if (hours > 0) {
        text += hours.toString();

        if (hours > 1)
            text += " " + qsTr("hours") + " ";
        else
            text += " " + qsTr("hour") + " ";
    }
    if (minutes > 0) {
        text += minutes.toString() + " " + qsTr("min") + " ";
    }
    if (seconds > 0) {
        text += seconds.toString() + " " + qsTr("sec") + " ";
    }
    if (ms > 0) {
        text += ms.toString() + " " + qsTr("ms");
    }

    return text;
}

/*!
 * durationToString_short()
 * Format is 'XX hours XX min XX sec XX ms'
 */
function durationToString_short(duration) {
    var text = '';

    if (duration <= 0) return qsTr("unknown");

    var hours = Math.floor(duration / 3600000);
    var minutes = Math.floor((duration - (hours * 3600000)) / 60000);
    var seconds = Math.floor((duration - (hours * 3600000) - (minutes * 60000)) / 1000);
    var ms = (duration - (hours * 3600000) - (minutes * 60000)) - (seconds * 1000);

    if (hours > 0) {
        text += hours.toString();

        if (hours > 1)
            text += " " + qsTr("hours") + " ";
        else
            text += " " + qsTr("hour") + " ";
    }
    if (minutes > 0) {
        text += minutes.toString() + " " + qsTr("min") + " ";
    }
    if (seconds > 0) {
        text += seconds.toString() + " " + qsTr("s") + " ";
    }
    if (ms > 0) {
        text += ms.toString() + " " + qsTr("ms");
    }

    return text;
}

/*!
 * durationToString_compact()
 * Format is 'XXh XXm XXs [XXms]'
 */
function durationToString_compact(duration) {
    var text = '';

    if (duration <= 0) return qsTr("unknown");

    var hours = Math.floor(duration / 3600000);
    var minutes = Math.floor((duration - (hours * 3600000)) / 60000);
    var seconds = Math.floor((duration - (hours * 3600000) - (minutes * 60000)) / 1000);
    var ms = (duration - (hours * 3600000) - (minutes * 60000)) - (seconds * 1000);

    if (hours > 0) {
        text += hours.toString() + qsTr("h") + " ";
    }
    if (minutes > 0) {
        text += minutes.toString() + qsTr("m") + " ";
    }
    if (seconds > 0) {
        text += seconds.toString() + qsTr("s") + " ";
    }

    if (seconds <= 1 && ms > 0) {
        text = ms.toString() + qsTr("ms");
    }

    return text;
}

/* ************************************************************************** */

/*!
 * durationToString_ISO8601_compact()
 * Format is 'mm:ss' (strict)

 * Note: great for displaying media current position in player
 * Ref: https://en.wikipedia.org/wiki/ISO_8601#Times
 */
function durationToString_ISO8601_compact(duration) {
    var text = '';

    if (duration > 1000) {
        var hours = Math.floor(duration / 3600000);
        var minutes = Math.floor((duration - (hours * 3600000)) / 60000);
        var seconds = Math.floor((duration - (hours * 3600000) - (minutes * 60000)) / 1000);

        if (hours > 0) text += padNumberInternal(hours).toString() + ":";
        text += padNumberInternal(minutes).toString() + ":";
        text += padNumberInternal(seconds).toString();
    } else {
        text = "00:00";
    }

    return text
}

/*!
 * durationToString_ISO8601_compact_loose()
 * Format is 'mm:ss' (loose)
 *
 * Note: great for displaying media duration in thumbnail
 * Ref: https://en.wikipedia.org/wiki/ISO_8601#Times
 */
function durationToString_ISO8601_compact_loose(duration) {
    var text = '';

    if (duration > 1000) {
        var hours = Math.floor(duration / 3600000);
        var minutes = Math.floor((duration - (hours * 3600000)) / 60000);
        var seconds = Math.round((duration - (hours * 3600000) - (minutes * 60000)) / 1000);

        if (hours > 0) text += padNumberInternal(hours).toString() + ":";
        text += padNumberInternal(minutes).toString() + ":";
        text += padNumberInternal(seconds).toString();
    } else if (duration > 0) {
        text = "~00:01";
    } else {
        text = "?";
    }

    return text
}

/*!
 * durationToString_ISO8601_regular()
 * Format is '00:00:00' (strict)
 *
 * Ref: https://en.wikipedia.org/wiki/ISO_8601#Times
 */
function durationToString_ISO8601_regular(duration_ms) {
    var text = '';

    if (duration_ms > 1000) {
        var hours = Math.floor(duration_ms / 3600000);
        var minutes = Math.floor((duration_ms - (hours * 3600000)) / 60000);
        var seconds = Math.round((duration_ms - (hours * 3600000) - (minutes * 60000)) / 1000);

        text += padNumberInternal(hours).toString() + ":";
        text += padNumberInternal(minutes).toString() + ":";
        text += padNumberInternal(seconds).toString();
    } else if (duration_ms > 0) {
        text = "00:00:01";
    } else {
        text = "00:00:00";
    }

    return text
}

/*!
 * durationToString_ISO8601_full()
 * Format is 'hh:mm:ss.sss' (strict)
 *
 * Note: format used by ffmpeg CLI
 * Ref: https://en.wikipedia.org/wiki/ISO_8601#Times
 */
function durationToString_ISO8601_full(duration_ms) {
    var text = '';

    if (duration_ms > 0) {
        var hours = Math.floor(duration_ms / 3600000);
        var minutes = Math.floor((duration_ms - (hours * 3600000)) / 60000);
        var seconds = Math.floor((duration_ms - (hours * 3600000) - (minutes * 60000)) / 1000);
        var milliseconds = Math.floor((duration_ms - (hours * 3600000) - (minutes * 60000)) - (seconds * 1000));

        if (hours > 0)
            text += padNumberInternal(hours).toString();
        if (hours === 0)
            text += "00";

        text += ":";

        if (minutes > 0)
            text += padNumberInternal(minutes).toString();
        if (minutes === 0)
            text += "00";

        text += ":";

        if (seconds > 0) {
            text += padNumberInternal(seconds).toString();
        if (seconds === 0)
            text += "00";
        if (milliseconds)
            text += "." + milliseconds.toString();
        }
    } else {
        text = "00:00:00";
    }

    return text
}

/* ************************************************************************** */

/*!
 * bytesToString_short()
 * unit: 0 is KB, 1 is KiB
 */
function bytesToString(bytes, unit) {
    var text = '';
    unit = unit || 0;

    var base = (unit === 1) ? 1024 : 1000
    //if (bytes > 1024*1024*1024*1024) return 'NaN';

    if (bytes > 0) {
        if ((bytes/(base*base*base)) >= 128.0)
            text = (bytes/(base*base*base)).toFixed(0) + " " + ((unit === 1) ? "GiB" : "GB");
        else if ((bytes/(base*base*base)) >= 1.0)
            text = (bytes/(base*base*base)).toFixed(1) + " " + ((unit === 1) ? "GiB" : "GB");
        else if ((bytes/(base*base)) >= 1.0)
            text = (bytes/(base*base)).toFixed(1) + " " + ((unit === 1) ? "MiB" : "MB");
        else if ((bytes/base) >= 1.0)
            text = (bytes/base).toFixed(1) + " " + ((unit === 1) ? "KiB" : "KB");
    }

    return text;
}

/*!
 * bytesToString_short()
 * unit: 0 is KB, 1 is KiB
 */
function bytesToString_short(bytes, unit) {
    var text = '';
    unit = unit || 0;

    var base = (unit === 1) ? 1024 : 1000
    //if (bytes > 1024*1024*1024*1024) return 'NaN';

    if (bytes > 0) {
        if ((bytes/(base*base*base)) >= 128.0)
            text = (bytes/(base*base*base)).toFixed(0) + " " + ((unit === 1) ? "GiB" : "GB");
        else if ((bytes/(base*base*base)) >= 1.0)
            text = (bytes/(base*base*base)).toFixed(1) + " " + ((unit === 1) ? "GiB" : "GB");
        else if ((bytes/(base*base)) >= 1.0)
            text = (bytes/(base*base)).toFixed(1) + " " + ((unit === 1) ? "MiB" : "MB");
        else if ((bytes/base) >= 1.0)
            text = (bytes/base).toFixed(1) + " " + ((unit === 1) ? "KiB" : "KB");
    }

    return text;
}

/* ************************************************************************** */

/*!
 * altitudeToString()
 */
function altitudeToString(value, precision, unit) {
    var text = '';
    unit = unit || 0;

    if (unit === 0) {
        text = value.toFixed(precision) + " " + qsTr("m");
    } else {
        text = (value / 0.3048).toFixed(precision) + " " + qsTr("ft");
    }

    return text;
}

/*!
 * altitudeUnit()
 */
function altitudeUnit(unit) {
    var text = '';
    unit = unit || 0;

    if (unit === 0) {
        text = qsTr("meter");
    } else {
        text = qsTr("feet");
    }

    return text;
}

/*!
 * distanceToString()
 */
function distanceToString(value, precision, unit) {
    var text = '';
    unit = unit || 0;

    if (unit === 0) {
        text = value.toFixed(precision) + " " + qsTr("km");
    } else {
        text = (value / 1609.344).toFixed(precision) + " " + qsTr("mi");
    }

    return text;
}

/*!
 * speedToString()
 */
function speedToString(value, precision, unit) {
    return distanceToString(value, precision, unit) + qsTr("/h");
}

/*!
 * speedUnit()
 */
function speedUnit(unit) {
    var text = '';

    if (unit === 0) {
        text = qsTr("km/h");
    } else {
        text = qsTr("mi/h");
    }

    return text;
}

/* ************************************************************************** */