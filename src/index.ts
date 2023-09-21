import axios from 'axios';
console.log('Loading function');
const DOCS = `
## Make an API call
Calls any (read-only) External API and displays the result as JSON.

### Widget parameters
Param | Description
---|---
**url** | The URL of the API
**method** | The method to use (get, post, put, delete)
**headers** | The headers to pass to the API
**params** | The parameters to pass to the API

### Example parameters
\`\`\` yaml
url: https://ec2.amazonaws.com/
method: post
params:
    id: 123456
data:
    firstname: Kamran
    lastname: Biglari
\`\`\`
`;

export const handler = async (event: any) => {
    if (event.describe) {
        return DOCS;   
    }
    console.log('Received event:', JSON.stringify(event));
    const response = await axios({
            method: event.method || 'get',
            url: event.url,
            responseType: 'json',
            headers: event.headers,
            data: event.params,
            params: event.params
        })
        .then((response) => response.data)
        .catch(function (error) {
            // handle error
            console.log(error);
        })
        .finally(function () {
            // always executed
        });
        // .then(function (response) {
        //     // handle success
        //     console.log(response);
        //     return {
        //         status: response.status,
        //         statusText: response.statusText,
        //         headers: response.headers,
        //         data: response.data
        //     };
        // })
    return response.status
};