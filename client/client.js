var n = 0;
function send(msg)
{
    for(var i in msg)
    {
        $.ajax({ url: '/' + msg[i],
                type: 'PUT',
                success: function(result) { console.log(result) }
                });
        console.log(n + " " + msg[i]);
    }
    n++;
    n = n % 20;
}

