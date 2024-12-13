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

Upon launching the app, the user will be presented with a button to select a file for upload.Users can select a file of at least 100 MB from their device storage. Once a file is selected, it will be automatically uploaded. Users can view the upload progress via a progress bar. After the upload is complete, a snackbar will appear to notify the user, and the uploaded video will be displayed in the video list. If users tap on a video, it will open in a new player screen where they can watch the video
