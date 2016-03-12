function readNewFile(event){
    var f = event.target.files[0];

    if (!f) {
        alert("Failed to load the file.");
    } else if (!f.type.match('text.*')) {
        alert(f.name + " is not a valid text file!");
    } else {
        // TODO: create json data for chart, create it
    }
}

function checkFileReaderSupport(){
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        document.getElementById('upload').addEventListener('change', readNewFile, false);
    } else {
        alert('The File APIs are not fully supported by your browser.');
        $('#upload').prop('disabled', true);
    }
}

$(document).ready(function(){
    checkFileReaderSupport();
});