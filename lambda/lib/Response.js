function buildHTMLResponse(body) {
    return {
        statusCode: 200,
        headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": true,
            "content-type": "text/html"
        },
        body
    };
}

module.exports = {
    html(body) {
        return buildHTMLResponse(body);
    }
};
