<%@ Page Language="C#" 
    AutoEventWireup="true" 
    CodeBehind="NotFound.aspx.cs" 
    Inherits="AlbumFront.NotFound" 
%>

<!DOCTYPE html>

<html lang="ru">
<head runat="server">
    <meta charset="utf-8" />
    <title>Страница не найдена</title>
    <meta name="robots" content="noindex, nofollow" />
    <style>
        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 2rem;
        }

        h1 {
            font-size: 1.8rem;
            margin-bottom: .5rem;
        }

        p {
            margin: .25rem 0;
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
        <h1>Страница не найдена (404)</h1>
        <p>Запрошенная страница не существует, была удалена или временно недоступна.</p>
        <p>
            Проверьте правильность адреса или перейдите на 
           <a href="<%: ResolveUrl("~/") %>">главную страницу</a>.
        </p>
    </form>
</body>
</html>
