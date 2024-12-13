Media Upload Application

Overview
This is a Flutter-based mobile application designed to allow users to upload large media files (such as videos or documents) to a backend service. The application supports background uploading, real-time progress tracking, video previews, error handling, and more.

Key Features:
1.File Upload: Upload media files (videos or documents) larger than 100MB.

2.Background Uploading: Uploads continue even when the app is in the background.

3.Progress Tracking: Real-time progress of the upload displayed with a progress bar.

4.Video Preview: If a video file is selected, a thumbnail or preview clip is shown before full playback.

5.Error Handling: Handles network failures, unsupported file types, and file size issues.


How the App Works
  1. Launching the App:
     Upon launching the app, the user will be presented with an option to select a file for upload.
 
    2.Selecting a File:
    Users can either choose a file from their device storage 

  3. Uploading the File: 
     . Start the upload automatically: The upload begins immediately after the user selects a file.
     . Real-time progress tracking: As the file uploads, a progress bar shows the percentage of the upload completed.
        . The app tracks the upload progress in the foreground.
        . Even if the app is closed or minimized, the upload continues in the background, and the user will receive a notification of the upload progress.
     
  5. Background Uploading:
      If the user switches away from the app or closes it, the upload will continue in the background. A persistent notification will show the upload progress, 
      allowing the user to monitor the upload even while not actively using the app.
     
  6.  Video Preview:
       . Thumbnail Preview: A thumbnail image of the video is shown once the file is selected.
       .Preview Clip: In some cases, a short preview clip of the video is generated, allowing users to see a portion of the video before deciding to upload it or 
         play the full video.
      
  7.  Resuming Uploads:
       The app supports persistent upload states. If the app is closed while a file is uploading, the app will remember the upload progress and resume uploading 
        once the app is reopened, as long as the file upload is still ongoing.

  8. File Validation:
       . File Size Check: The app ensures that only files that meet the required size of 100MB or more can be uploaded.
       .  Supported File Types: Unsupported file types will prompt an error, and the user will be asked to select a different file.   

     
Upon launching the app, the user will be presented with a button to select a file for upload.Users can select a file of at least 100 MB from their device storage. Once a file is selected, it will be automatically uploaded. Users can view the upload progress via a progress bar. After the upload is complete, a snackbar will appear to notify the user, and the uploaded video will be displayed in the video list. If users tap on a video, it will open in a new player screen where they can watch the video
