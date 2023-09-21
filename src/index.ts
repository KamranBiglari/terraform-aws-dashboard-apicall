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
    if (event.action == 'view') {
        return `
        <form>
        <table style="width:100%">
        <tr>
            <td>URL</td>
            <td>
            <select name="method" style="padding:0 1rem 0px 2px">
                <option value="get">GET</option>
                <option value="post">POST</option>
                <option value="put">PUT</option>
                <option value="delete">DELETE</option>
            </select></td><td><input type="text" name="url" value="https://aws.amazon.com" style="width:100%" /></td>
        </tr>
        <tr>
            <td>Params</td>
            <td colspan="2"><input type="text" name="params" value="" style="width:100%" /></td>
        </tr>
        <tr>
            <td>Headers</td>
            <td colspan="2"><input type="text" name="headers" value="" style="width:100%" /></td>
        </tr>
        <tr>
            <td>Data</td>
            <td colspan="2"><input type="text" name="data" value="" style="width:100%" /></td>
        </tr>
        <tr>
            <td colspan="2"><a class="btn btn-primary">Execute</a>
            <cwdb-action action="call" endpoint="arn:aws:lambda:eu-west-2:050253647064:function:terraform-aws-dashboard-apicall" display="popup">  
            { 
                "action": "execute",
            }
            </cwdb-action>
            </td>
        </tr>
        </table>
        </form>
        `;
    }
    console.log('Received event:', JSON.stringify(event));
    event = event['widgetContext']['forms']['all'];
    const response = await axios({
            method: event.method || 'get',
            url: event.url,
            responseType: 'json',
            // headers: event.headers || {},
            // data: event.data || {},
            // params: event.params || {}
        })
        .then((response) => {
            return {
                status: response.status,
                statusText: response.statusText,
                headers: response.headers,
                data: response.data
            }
        })
        .catch(function (error) {
            // handle error
            console.log(error);
        })
        .finally(function () {
            // always executed
        });
        return response;
};