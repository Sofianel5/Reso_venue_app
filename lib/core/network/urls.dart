class Urls {
  static const bool Debug = false;
  static String getBaseURL() => Debug ? "http://127.0.0.1:8000/" : "https://api.tracery.us/";
  static String LOGIN_URL = getBaseURL() + "api/auth/token/login/";
  static String USER_URL = getBaseURL() + "api/myadmin/";
  static String getTimeSlotsForId(int id) {
    return getBaseURL() + "api/myadmin/venues/" + id.toString() + "/timeslots/";
  }
  static String getScanUrl(int id) {
    return getBaseURL() + "api/venues/" + id.toString() + "/scan/";
  }
  static String addTimeSlotUrl(int id) {
    return getBaseURL() + "api/venues/" + id.toString() + "/timeslots/";
  }
  static String deleteTimeSlot(int venueId, int tsid) {
    return getBaseURL() + "api/myadmin/venues/" + venueId.toString() + "/timeslots/" + tsid.toString() + "/";
  }
  static String PASSWORD_RESET_URL = getBaseURL() + "users/password/reset/";
  static String getHelpUrl(int venueId) {
    return getBaseURL() + "api/myadmin/" + venueId.toString() + "/help/";
  }
  static String getChangeTimeslotUrl(int venueid, int timeslotid) {
    return getBaseURL() + "api/myadmin/" + venueid.toString() + "/timeslots/" + timeslotid.toString() + "/change-external-attendees/";
  }

  static String getClearUrl(int venueId) {
    return getBaseURL() + "api/myadmin/" + venueId.toString() + "/clear/";
  }

  static String getIncrementUrl(int venueId) {
    return getBaseURL() + "api/myadmin/" + venueId.toString() + "/increment/";
  }
  
}