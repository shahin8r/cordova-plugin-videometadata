# cordova-plugin-videometadata
Returns `width, height, rotation, duration, bitrate` of video files.

Works with `iOS` and `Android`.

Use this until Cordova resolves their [issue with MediaFile.getFormatData()](https://issues.apache.org/jira/browse/CB-7117).

## Usage

```
cordova.plugins.VideoMetadata.file(videoFile, function(data) {
    // data contains all our metadata
    if (data.rotation == 90 || data.rotation == -90) {
        alert("No vertical vids please");
    }
}, function(error) {
    // error
});
```