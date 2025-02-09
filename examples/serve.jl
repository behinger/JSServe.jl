using JSServe, Observables
using JSServe: @js_str, onjs, Button, TextField, Slider, linkjs, Session, App
using JSServe.DOM
using Hyperscript

app = App() do session::Session
    s1 = Slider(1:100)
    s2 = Slider(1:100)
    b = Button("hi")
    t = TextField("enter your text")
    on(println, s1.value)
    linkjs(session, s1.value, s2.value)
    test = [1,2,3]
    onjs(session, s1.value, js"(v)=> console.log($test)")
    on(t) do text
        println(text)
    end
    return DOM.div(s1, s2, b, t)
end;

if isdefined(Main, :server)
    close(server)
end

server = JSServe.Server(app, "127.0.0.1", 8081)
# Important Note: You might want to set the keyword argument `proxy_url` above in case
# you have a reverse proxy (like nginx or caddy) in front of the JSServe instance.
JSServe.HTTPServer.start(server)
# JSServe.HTTPServer.route!(server, "/" => app) # Overwrite app after changing it
wait(server)
