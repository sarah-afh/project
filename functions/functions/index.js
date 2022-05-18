const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
admin.initializeApp(functions.config().firebase);

exports.AS7262 = functions.database
  .ref("/AS7262/{pushId}")
  .onCreate(async (snapshot, context) => {
    return checkForAnomaliesAndNotifyUsers(
      snapshot.val(),
      "AS7262",
      context.params.pushId
    );
  });
exports.BH1745 = functions.database
  .ref("/BH1745/{pushId}")
  .onCreate(async (snapshot, context) => {
    return checkForAnomaliesAndNotifyUsers(
      snapshot.val(),
      "BH1745",
      context.params.pushId
    );
  });
exports.BME680 = functions.database
  .ref("/BME680/{pushId}")
  .onCreate(async (snapshot, context) => {
    return checkForAnomaliesAndNotifyUsers(
      snapshot.val(),
      "BME680",
      context.params.pushId
    );
  });
exports.LSM303D = functions.database
  .ref("/LSM303D/{pushId}")
  .onCreate(async (snapshot, context) => {
    return checkForAnomaliesAndNotifyUsers(
      snapshot.val(),
      "LSM303D",
      context.params.pushId
    );
  });
exports.LTR_559 = functions.database
  .ref("/LTR_559/{pushId}")
  .onCreate(async (snapshot, context) => {
    return checkForAnomaliesAndNotifyUsers(
      snapshot.val(),
      "LTR_559",
      context.params.pushId
    );
  });

/**
 * this function perfoms anomaly detection and
 * notifies users.
 *
 * @param {*} data new entry from sensorhub
 * @param {*} sensorCode sensor id
 */
async function checkForAnomaliesAndNotifyUsers(data, sensorCode, docId) {
  const date = data.time;
  const properties = Object.keys(data).filter(
    (property) => property !== "time"
  );
  const checks = [];

  for (const [property, value] of Object.entries(data)) {
    if (property !== "time") {
      checks.push(
        detectAnomaly(buildBaseApiUrl(sensorCode, property), date, value)
      );
    }
  }

  const results = await Promise.all(checks);
  const anomaly = {};
  results.forEach((isAnomaly, index) => {
    if (isAnomaly) {
      const property = properties[index];
      anomaly[property] = data[property];
    }
  });
  if (anomaly.size === 0) {
    return;
  }
  anomaly["time"] = date;
  anomaly["docId"] = docId;
  anomaly["sensorCode"] = sensorCode;
  await saveNewAnomaly(anomaly);
  await notifyUsers(sensorCode);
}

/**
 * saves a new entry in the firestore "Anomalies" collection
 *
 */
async function saveNewAnomaly(anomaly) {
  const collection = "Anomalies";
  const db = admin.firestore();
  return db.collection(collection).add(anomaly);
}

/**
 *  pushes a new notification to the specific fcm topic
 */

async function notifyUsers(sensorCode) {
  const topic = sensorCode + "_topic";
  const notification = {
    title: "Anomaly Detected",
    body:
      "An anomaly detected from the sensor: " + resolveSensorName(sensorCode),
    clickAction: "FLUTTER_NOTIFICATION_CLICK",
  };
  functions.logger.log("Sending notification to: ", topic, " ", notification);
  return admin.messaging().sendToTopic(topic, {
    notification: notification,
  });
}

/**
 *  calls ml model api and checks if the given values correspond to a anomaly
 */

async function detectAnomaly(url, date, value) {
  functions.logger.log("calling : ", url, " ", value);
  const response = await axios({
    method: "GET",
    url: url,
    params: {
      time: date,
      value: value,
    },
  });

  return response.data === 1;
}

/**
 * builds the ml model api base url
 */

function buildBaseApiUrl(sensorCode, property) {
  return "https://" + sensorCode + "-" + property + ".herokuapp.com/predict";
}

/**
 * maps sensor code to it's name
 */
function resolveSensorName(sensorCode) {
  switch (sensorCode) {
    case "AS7262":
      return "Spectrum";
    case "BH1745":
      return "Color and Luminous";
    case "BME680":
      return "Air Quality";
    case "LSM303D":
      return "Motion";
    case "LTR_559":
      return "LTR_559";
    default:
      return "";
  }
}
