import { ChangeEvent } from 'react';
import apiClient from '../http-common';

function UploadDataset() {
    const fd = new FormData();

    const handleFileReader = (event: ChangeEvent<HTMLInputElement>) => {
        fd.append("dataset", event.target.files![0]);
        fd.append("password", "abc");
    }
  
    const uploadHandler = () => {
        apiClient.post("/dataset", fd, { headers: {'Content-Type': 'multipart/form-data'} })
    };
  
    return (
      <div>
        <div className="mb-3">
            <label className="form-label">Upload Dataset .zip file</label>
            <input className="form-control" type="file" accept=".zip" />
        </div>
       {/* <label>Upload Dataset .zip file</label>
         <input
          onChange={handleFileReader}              
          type="file"
          accept=".zip"
         /> */}
        <button type="button" className="btn btn-primary" onClick={uploadHandler}>
           Upload Folder
        </button>
      </div>
    );
}

export default UploadDataset;