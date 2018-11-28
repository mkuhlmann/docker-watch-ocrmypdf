
# watch-ocrmypdf

Small bash script that watches a directory (/consume), runs [ocrmypdf](https://github.com/jbarlow83/OCRmyPDF) on any supported files (.pdf, .jpg, .png) and executes a user-defined command afterwards (rclone is included in docker image to copy resulting file to various remotes)


## Docker

Run mkuhlmann/watch-ocrmypdf and mount the directory that should be watched to /consume. You can customize ocrmypdf command line arguments via the `OCRWATCH_OCRMYPDF` enviroment variable. The command to be executed after ocr'ing should be supplied via `OCRWATCH_AFTER`, in which `%FILE` will be replaced with the path to the output pdf.

See `docker-compose.yml` for an example that uses atmoz/sftp:alpine to provide a sftp server as remote for a document scanner and uploads the file to nextcloud afterwards.


# Contributing

Any pull requests are *very* welcome.

# License

The MIT License (MIT)

Copyright (c) 2018 Manuel Kuhlmann

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.