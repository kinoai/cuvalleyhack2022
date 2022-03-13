import React from 'react';
import UploadDataset from './UploadDataset';

function iframe() {
    return {
        __html: '<iframe src="chart.html" width="100%" height="100%"></iframe>'
    }
}

export default function Chart() {
    return (
        <div>
            <div style={{"width": "100%", "height": "100%"}} dangerouslySetInnerHTML={iframe()} />
            <UploadDataset />
        </div>
    )
}