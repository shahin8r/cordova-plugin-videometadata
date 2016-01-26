package com.shahin8r.plugin;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.media.*;
import android.net.Uri;
import java.net.URI;
import android.database.Cursor;
import android.provider.MediaStore;
import android.content.Context;

public class VideoMetadata extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        if (action.equals("file")) {

            Uri src = Uri.parse(args.getString(0));

            MediaMetadataRetriever metaRetriever = new MediaMetadataRetriever();

            metaRetriever.setDataSource(getRealPathFromURI(src));
            
            int width = Integer.valueOf(metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH));
            int rotation = Integer.valueOf(metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION));
            int height = Integer.valueOf(metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT));
            int duration = Integer.valueOf(metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
            int bitrate = Integer.valueOf(metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_BITRATE));

            JSONObject metadata = new JSONObject();

            metadata.put("width", width);
            metadata.put("height", height);
            metadata.put("rotation", rotation);
            metadata.put("duration", duration);
            metadata.put("bitrate", bitrate);

            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, metadata));

            return true;

        } else {

            return false;

        }
    }

    public String getRealPathFromURI(Uri contentUri) {

        Cursor cursor = null;

        try {

            Context mContext = this.cordova.getActivity().getApplicationContext();

            String[] proj = { MediaStore.Images.Media.DATA };
            cursor = mContext.getContentResolver().query(contentUri, proj, null, null, null);

            int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();

            return cursor.getString(column_index);

        } catch (Exception e) {

            //error handler

        } finally {

            if (cursor != null) {
                cursor.close();
            }

        }

        return contentUri.getPath();

    }

}