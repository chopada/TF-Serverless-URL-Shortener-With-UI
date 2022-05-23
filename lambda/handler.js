const Response = require('./lib/Response');

const html404 = `<!DOCTYPE html>
<body>
  <h1>404 Not Found.</h1>
  <p>The url you visit is not found.</p>
</body>`

const htmlBody = (apiUrl) => {
    return `
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>URL Shortener</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700;900&display=swap');

        *,
        body {
            font-family: 'Poppins', sans-serif;
            font-weight: 400;
            -webkit-font-smoothing: antialiased;
            text-rendering: optimizeLegibility;
            -moz-osx-font-smoothing: grayscale;
        }

        html,
        body {
            height: 100%;
            overflow: hidden;
        }

        .form-holder {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            min-height: 100vh;
        }

        .form-holder .form-content {
            position: relative;
            text-align: center;
            display: -webkit-box;
            display: -moz-box;
            display: -ms-flexbox;
            display: -webkit-flex;
            display: flex;
            -webkit-justify-content: center;
            justify-content: center;
            -webkit-align-items: center;
            align-items: center;
            padding: 60px;
        }

        .form-content .form-items {
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            background: white;
            padding: 40px;
            display: inline-block;
            width: 100%;
            min-width: 800px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            border-radius: 10px;
            text-align: left;
            -webkit-transition: all 0.4s ease;
            transition: all 0.4s ease;
        }

        .form-content h3 {
            text-align: left;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .form-content h3.form-title {
            margin-bottom: 30px;
        }

        .form-content p {
            text-align: left;
            font-size: 17px;
            font-weight: 300;
            line-height: 20px;
            margin-bottom: 30px;
        }

        .form-content input[type=text],
        .form-content input[type=password],
        .form-content input[type=email],
        .form-content select {
            width: 100%;
            padding: 9px 20px;
            text-align: left;
            outline: 0;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 300;
            -webkit-transition: all 0.3s ease;
            transition: all 0.3s ease;
            margin-top: 16px;
        }

        .btn-primary {
            background-color: #e1ecf4;
            border-radius: 3px;
            border: 1px solid #7aa7c7;
            box-shadow: rgba(255, 255, 255, .7) 0 1px 0 0 inset;
            box-sizing: border-box;
            color: #39739d;
            cursor: pointer;
            display: inline-block;
            font-family: -apple-system, system-ui, "Segoe UI", "Liberation Sans", sans-serif;
            font-weight: 600;
            line-height: 1.15385;
            margin: 0;
            outline: none;
            padding: 8px .8em;
            position: relative;
            text-align: center;
            text-decoration: none;
            user-select: none;
            -webkit-user-select: none;
            touch-action: manipulation;
            vertical-align: baseline;
            white-space: nowrap;
        }


        .btn-primary:hover,
        .btn-primary:focus {
            background-color: #b3d3ea;
            color: #2c5777;
        }

        .btn-primary:focus {
            box-shadow: 0 0 0 4px rgba(0, 149, 255, .15);
        }

        .btn-primary:active {
            background-color: #a0c7e4;
            box-shadow: none;
            color: #2c5777;
        }

        .done {
            position: absolute;
            left: -15px;
            top: 0;
            right: 0;
            text-align: center;
            opacity: 0;
            transform: translateY(-1em);
            color: #000;
            transition: all .500s;
        }

        .copied .done {
            opacity: 1;
            transform: translateY(-2em);
        }

        .popup {
            white-space: nowrap;
            text-overflow: ellipsis;
            position: absolute;
            left: -65px;
            top: 0;
            right: 0;
            text-align: center;
            opacity: 0;
            transform: translateY(-1em);
            color: #000;
            transition: all .500s;
        }

        .raise .popup {
            opacity: 1;
            transform: translateY(-2em);
        }

        .btn-copy {
            position: relative;
            margin-left: 15px;
            border: 0;
            font-size: 0.835em;
            text-transform: uppercase;
            letter-spacing: 0.125em;
            font-weight: bold;
            transition: background .275s;
            color: #39739d;
            background-color: #e1ecf4;
        }

        .btn-copy:hover,
        .btn-copy:focus {
            background-color: #b3d3ea;
            color: #2c5777;
        }
    </style>
    <script>
        const copyURLMouseEnter = () => {
            var btnCopy = document.getElementById('copy');
            btnCopy.classList.add('raise');
        }
        const copyURLMouseLeave = () => {
            var btnCopy = document.getElementById('copy');
            btnCopy.classList.remove('raise');
        }
        const copyURL = () => {
            var toCopy = document.getElementById('short-url'),
                btnCopy = document.getElementById('copy');
            btnCopy.classList.remove('raise');
            var input = document.createElement('input');
            input.setAttribute('value', toCopy.href);
            document.body.appendChild(input);
            input.select();

            if (document.execCommand('copy')) {
                btnCopy.classList.add('copied');

                var temp = setInterval(function () {
                    btnCopy.classList.remove('copied');
                    clearInterval(temp);
                }, 600);

            } else {
                console.info('document.execCommand went wrong…')
            }
            document.body.removeChild(input);
            return false;
        };

        const submitURL = () => {

            document.getElementById("status").innerHTML = "Creating short url"
            //await call url for new shortlink and return
            long = document.getElementById("url").value;
            short = document.getElementById("shortid").value;
            const object = {
                longURL: long,
                shortURL: short,
                owner: "Tushar"
            }
            fetch("${apiUrl}url-shortener", {
                method: "POST",
                body: JSON.stringify(object),
                headers: {
                    'Content-Type': 'application/json'
                }
            })
                .then(data => data.json())
                .then(data => {
                    console.log('ready')
                    document.getElementById("status").innerHTML = "Your short URL: <a id=short-url href=" + data.shortURL + " target=_blank>" + data.shortURL + "</a><button onclick=copyURL() onmouseenter=copyURLMouseEnter() onmouseleave=copyURLMouseLeave() id=copy class=btn-copy type=button><i class='fa fa-clipboard'></i><span class=done aria-hidden=true>Copied</span><span class=popup aria-hidden=true>Copy To Clipboard</span></button>"
                })
        }
    </script>
</head>

<body>
    <div class="form-body">
        <div class="row">
            <div class="form-holder">
                <div class="form-content">
                    <div class="form-items">
                        <h3 class="text-center mx-auto">The URL Shortener</h3>
                        <p class="text-center mx-auto">Shorten Big URLs</p>
                        <div class="col-md-12">
                            <input class="form-control" type="text" id="url" placeholder="Enter the URL" required>
                        </div>
                        <div class="col-md-12">
                            <input class="form-control" type="text" id="shortid" placeholder="Provide an Alias"
                                required>
                        </div>
                        <div class="form-button mt-4 text-center mx-auto ">
                            <button id="submit" onclick="submitURL()" class="btn btn-primary">Shorten</button>
                        </div>
                        <div class=" col-md-12 mt-5 text-center mx-auto">
                            <label class="form-check-label" id="status"></label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
</body>

</html>
`}

module.exports.rootUrlShortener = async (event) => {
    console.log(JSON.stringify(event));
    const { requestContext: { domainName, path } } = event;
    return Response.html(htmlBody(`https://${domainName}${path}`));
}