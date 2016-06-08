'use strict';

const math = require('mathjs');
const Polygon = require('d3-polygon');

class NearestNeighborIndexProcessor {
    calculate(fixationPoints) {
        let convexHullPoints = this.calculateConvexHull(fixationPoints);
        let area = this.calculateArea(convexHullPoints);
        let perimeter = this.calculatePerimeter(convexHullPoints);
        let averageDistance = this.calculateAverageDistance(fixationPoints);

        let denom = 0.5 * math.sqrt(area/fixationPoints.length);

        let nni = [];
        let d_ran = [];

        nni.push(averageDistance/denom);
        d_ran.push(denom);

        denom = denom + (0.0514 + 0.041 / math.sqrt(fixationPoints.length)) * (perimeter / fixationPoints.length);

        nni.push(averageDistance/denom);
        d_ran.push(denom);
        
        return {
            nni: nni,
            area: area,
            d_ran: d_ran,
            averageDistance: averageDistance
        };
    }

    calculateConvexHull(fixationPoints) {
        return Polygon.polygonHull(fixationPoints);
    }

    calculateArea(convexHullPoints) {
        return Math.abs(Polygon.polygonArea(convexHullPoints));
    }

    calculatePerimeter(convexHullPoints) {
        return Math.floor(Polygon.polygonLength(convexHullPoints));
    }

    calculateAverageDistance(fixationPoints) {
        let totalDistance = 0;

        for(let i = 0; i < fixationPoints.length; i++) {
            let minimumDistance = Infinity;

            for(let j = 0; j < fixationPoints.length; j++) {
                if(i != j) {
                    let m = math.norm(math.subtract(fixationPoints[i], fixationPoints[j]));
                    minimumDistance = math.min(minimumDistance, m);
                }
            }

            totalDistance = totalDistance + minimumDistance;
        }

        return (totalDistance / fixationPoints.length);
    }
}

export default NearestNeighborIndexProcessor
