from concat_js import *


models = []
views = []
stylesheets = []

for p in os.listdir( "modules" ):
    for m in os.listdir("modules/" + p):
        if m == "models":
            models.append("gen/" + m + "/" + p + ".js")
            concat_js( "modules/" + p + "/" + m, "gen/" + m + "/" + p + ".js", "gen/stylesheets/" + p + ".css" )

        elif m == "views":
            views.append("gen/" + m + "/" + p + ".js")
            concat_js( "modules/" + p + "/" + m, "gen/" + m + "/" + p + ".js", "gen/stylesheets/" + p + ".css" )

        elif m == "stylesheets":
            stylesheets.append("gen/" + m + "/" + p + ".css")
            concat_js( "modules/" + p + "/" + m, "gen/" + m + "/" + p + ".js", "gen/stylesheets/" + p + ".css" )

exec_cmd( "echo > models.js " )
exec_cmd( "echo > processes.js " )
exec_cmd( "echo > stylesheets.css " )

for m in sorted(models):
    exec_cmd( "cat models.js " + m + " > models_tmp.js" )
    exec_cmd( "mv models_tmp.js models.js" )
for v in sorted(views):
    exec_cmd( "cat processes.js " + v + " > processes_tmp.js" )
    exec_cmd( "mv processes_tmp.js processes.js" )
for s in sorted(stylesheets):
    exec_cmd( "cat stylesheets.css " + s + " > stylesheets_tmp.css" )
    exec_cmd( "mv stylesheets_tmp.css stylesheets.css" )

exec_cmd( "cp modules/Admin/admin.html ../../organs/browser" )
exec_cmd( "cp modules/Desk/desk.html ../../organs/browser" )
exec_cmd( "cp modules/Lab/lab.html ../../organs/browser" )
