import React from 'react';

function iframe() {
    return {
        __html: '<iframe src="chart.html" width="100%" height="100%"></iframe>'
    }
}

console.log(process.env)
export default function Chart() {
    return (<div style={{"width": "100%", "height": "100%"}} dangerouslySetInnerHTML={iframe()} />)
}