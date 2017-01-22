'use strict';

import NearestNeighborIndexProcessor from './NearestNeighborIndexProcessor';

class FixationsDataProcessor {

    constructor() {
        this.fixationsData = [];
        this.nniProcessor = new NearestNeighborIndexProcessor();
    }

    getScreenResolution(fileContentsAsArray)
    {
        let firstLine = fileContentsAsArray[0];
        let resolution = firstLine.split(' ');

        return {
            width: parseInt(resolution[0]),
            height: parseInt(resolution[1])
        }
    }

    process(fileContentsAsArray)
    {
        fileContentsAsArray.splice(0, 1);

        for(let c in fileContentsAsArray) {
            let lineItems = fileContentsAsArray[c].split(' ');

            this.addItemToMinute([lineItems[1], lineItems[2]], this.getMinuteFromTimestamp(parseInt(lineItems[0])));
        }

        for(let i in this.fixationsData) {
            this.fixationsData[i]['nni'] = this.nniProcessor.calculate(this.fixationsData[i].points);
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
        let minute = Math.floor(timestamp / 1000 / 60);
        return minute;
    }

}

export default FixationsDataProcessor
