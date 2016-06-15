var tValues = [];
var xValues = [];
var yValues = [];

function populateValues(valuesFileLines) {
    var line;
    for(var c in valuesFileLines) {
        if(c != valuesFileLines.length - 1) {
            line = valuesFileLines[c].split(' ');

            tValues.push(line[0]);
            xValues.push(line[1]);
            yValues.push(line[2]);
        }
    }
}

function buildChart() {
    resetCanvas();

    var data = {
        labels: tValues,
        datasets: [
            {
                label: "X Coordinate",
                fillColor: "rgba(220,220,220,0.2)",
                strokeColor: "rgba(220,220,220,1)",
                pointColor: "rgba(220,220,220,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                data: xValues
            },
            {
                label: "Y Coordinate",
                fillColor: "rgba(151,187,205,0.2)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(151,187,205,1)",
                data: yValues
            }
        ]
    };

    var ctx = document.getElementById("chart").getContext("2d");
    var myLineChart = new Chart(ctx).Line(data);
}

// Note: in this validation function the final empty line is not contemplated.
function isAValidFile(fileContentArray) {
    if(/(\d{1,}) (\d{1,})/.exec(fileContentArray[0]) === null){
        return false;
    }

    var restOfTheFile = fileContentArray.slice().splice(1);

    for(var c in restOfTheFile) {
        var currentLine = restOfTheFile[c];

        if(c == restOfTheFile.length - 1) {
            if(currentLine != '' && /(\d{1,}) (\d{1,}) (\d{1,})/.exec(restOfTheFile[c]) === null) {
                return false;
            }
        } else {
            if(/(\d{1,}) (\d{1,}) (\d{1,})/.exec(restOfTheFile[c]) === null) {
                return false;
            }
        }
    }

    return true;
}

function readNewFile(event){
    tValues = [];
    xValues = [];
    yValues = [];

    var file = event.target.files[0];

    if (!file) {
        alert("Failed to load the file.");
    } else if (!file.type.match('text.*')) {
        alert(file.name + " is not a valid text file!");
    } else {
        var fileReader = new FileReader();

        fileReader.onload = function(event) {
            var fileContentArray = fileReader.result.split("\n");

            if(isAValidFile(fileContentArray)) {
                var valuesFileLines = fileContentArray.slice().splice(1);

                populateValues(valuesFileLines);
                buildChart();
            } else {
                alert('The uploaded file does not respect the requested format.');
            }
        };

        fileReader.readAsText(file);
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

function resetCanvas() {
    $('#chart').remove();
    $('#canvas-container').html('<canvas id="chart"></canvas>');
}

$(document).ready(function(){
    Chart.defaults.global.responsive = true;
    checkFileReaderSupport();
});
