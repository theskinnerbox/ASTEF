'use strict';

class FixationsDataProcessor {

    constructor() {
        this.fixationsData = [];
    }

    process(fileContentsAsArray)
    {
        for(var c in fileContentsAsArray) {
            let lineItems = fileContentsAsArray[c].split(' ');

            this.addItemToMinute({
                x: parseInt(lineItems[1]),
                y: parseInt(lineItems[2])
            }, this.getMinuteFromTimestamp(parseInt(lineItems[0])));
        }

        return this.fixationsData;
    }

    addItemToMinute(point, minute)
    {
        if(this.fixationsData[minute] === undefined) {
            this.fixationsData[minute] = {
                points: [point]
            }
        } else {
            this.fixationsData[minute].points.push(point);
        }
    }

    getMinuteFromTimestamp(timestamp) {
        let minute = Math.floor(timestamp * 1.67 * 0.00001);
        return minute;
    }

}

export default FixationsDataProcessor
