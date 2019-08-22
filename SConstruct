import os

ELM = "elm.js"
MINJS = "minelm.js"
CSS = "compiled.css"

# Creates a Phony target
def PhonyTargets(
        target,
        action,
        depends,
        env=None,
):
    if not env: env = DefaultEnvironment()
    t = env.Alias(target, depends, action)
    env.AlwaysBuild(t)


env_options = {
    "ENV": os.environ,
}

scsssrc = Glob("scss/*.scss")
elmsrc = Glob("src/*.elm")

env = Environment(**env_options)

final = env.Alias("all", [MINJS, CSS])
env.Default(final)

env.Command(ELM, elmsrc, "elm make src/main.elm --output={}".format(ELM))
env.Command(MINJS, ELM, "./node_modules/.bin/uglifyjs {} --compress --output {}".format(ELM, MINJS))
env.Command(CSS, scsssrc, "sass scss/custom.scss > {}".format(CSS))
