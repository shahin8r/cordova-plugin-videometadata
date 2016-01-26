module.exports = {
    file: function (src, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "VideoMetadata", "file", [src]);
    }
};