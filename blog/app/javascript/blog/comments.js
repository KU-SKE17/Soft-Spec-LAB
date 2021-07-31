(function () {
    document.addEventListener("turbolinks:load", function () {
        let commentButtons = document.getElementsByClassName("btn-comment")

        Array.from(commentButtons).forEach( function (button) {
            button.addEventListener("click", function () {
                loadComments(this.getAttribute("article"))
            })
        })

        function loadComments(articleId) {
            let host = window.location.protocol + "//" + window.location.host;
            // url = host + protocol + path
            let url = host + "/api/v1/articles/" + articleId + "/comments"
            let http = new XMLHttpRequest()

            http.onreadystatechange = function () {
                if (http.readyState == XMLHttpRequest.DONE) {
                    if (http.status == 200) {
                        let comments = JSON.parse(http.responseText)
                        let commentsView = document.getElementById("comments-"+articleId)
                        commentsView.innerHTML = ""

                        comments.forEach(function (comment) {
                            let commentsRow = document.createElement("div")
                            commentsRow.innerHTML = comment.author + " : " + comment.text
                            commentsView.append(commentsRow)
                        })
                    } else {
                        console.log("The Request failed.")
                    }
                }
            }
            http.open("GET", url)
            http.send()
        }
    })
}) ()