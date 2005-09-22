@dir /b /s 2das\*.2da | tools\ssed -R "$! {s/$/\"/g};s/^/\"/g" | java -Xmx150m -jar tools\prc.jar 2da -n - 2>&1
@pause
