window.addEventListener('message', function(event) {
    let data = event.data;
    let container = document.getElementById('news-container');

    if (data.action === "SHOW_UI") {
        container.style.display = "block";
    } else if (data.action === "HIDE_UI") {
        container.style.display = "none";
    }
});