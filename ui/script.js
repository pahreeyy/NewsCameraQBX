window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.action === "SHOW_UI") {
        document.getElementById('news-container').style.display = "block";
        document.getElementById('header').innerText = data.header;
        document.getElementById('title').innerText = data.title;
        document.getElementById('summary').innerText = data.summary;
    } else if (data.action === "HIDE_UI") {
        document.getElementById('news-container').style.display = "none";
    }
});