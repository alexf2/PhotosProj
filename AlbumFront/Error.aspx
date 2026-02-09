<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="AlbumFront.Error" %>

<!DOCTYPE html>
<html lang="ru">
<head runat="server">
    <meta charset="utf-8" />
    <title>Ошибка на сайте</title>
    <meta name="robots" content="noindex,nofollow" />
    <style>
        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 2rem;
        }

        h1 {
            font-size: 1.8rem;
        }

        p {
            margin-top: .5rem;
            max-width: 40rem;
        }

        a {
            color: #0066cc;
            text-decoration: none;
        }

            a:hover {
                text-decoration: underline;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>На сайте произошла ошибка</h1>
        <p>
            К сожалению, при обработке запроса возникла непредвиденная ошибка.
        Мы уже работаем над её устранением.
        </p>
        <p>
            Вы можете <a href="<%: ResolveUrl("~/") %>">вернуться на главную страницу</a>
            или попробовать зайти позже.
        </p>
    </form>
</body>
