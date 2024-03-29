// from : https://usefulangle.com/post/352/javascript-capture-image-from-camera
$(document).ready(function () {

    let camera_button = document.querySelector("#webcam-start-camera");
    let video = document.querySelector("#webcam-video");
    let click_button = document.querySelector("#webcam-click-photo");
    let stop_camera = document.querySelector("#webcam-stop-camera");
    let canvas = document.querySelector("#webcam-canvas");

    camera_button.addEventListener('click', async function () {
        let stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
        video.srcObject = stream;
    });

    stop_camera.addEventListener('click', async function () {
        let stream = video.srcObject;
        let tracks = stream.getTracks();
        // Merci Copilot :p 
        tracks.forEach(function (track) {
            track.stop();
        });
        video.srcObject = null;
        video.ariaHidden = true;
    });

    click_button.addEventListener('click', function () {
        canvas.style.display = "block";
        canvas.getContext('2d').drawImage(video, 0, 0, canvas.width, canvas.height);
        let image_data_url = canvas.toDataURL('image/jpeg');
        Shiny.setInputValue('base64url', image_data_url, { priority: 'event' });
        canvas.style.display = "none";
    });
});