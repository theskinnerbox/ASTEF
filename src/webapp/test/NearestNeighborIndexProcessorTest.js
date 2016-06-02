'use strict';

import NearestNeighborIndexProcessor from '../src/Processors/NearestNeighborIndexProcessor';
import { assert } from 'chai';

var processor = new NearestNeighborIndexProcessor();

describe('NearestNeighborIndexProcessor', function() {
    describe('calculateAverageDistance()', function () {
        it('can correctly calculate average distance #1', function () {
            assert.equal(1, processor.calculateAverageDistance([
                [0, 0], [1, 0], [0, 1]
            ]));
        });

        it('can correctly calculate average distance #2', function () {
            assert.equal(1, processor.calculateAverageDistance([
                [0, 0], [1, 0], [1,1], [0, 1]
            ]));
        });
    });
});
