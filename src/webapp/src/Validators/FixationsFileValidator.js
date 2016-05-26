'use strict';

class FixationsFileValidator {
    validate(fileContents) {
        if(/(\d{1,}) (\d{1,})/.exec(fileContents[0]) === null){
            return false;
        }

        var restOfTheFile = fileContents.slice().splice(2);

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
}

export default FixationsFileValidator
