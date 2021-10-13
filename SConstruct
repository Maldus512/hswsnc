import os

ELMJS = "res/js/elm.js"
MINJS = "res/js/minelm.js"
CSS = "res/css/compiled.css"

SASS = "./node_modules/.bin/sass"
UGLIFYJS = './node_modules/.bin/uglifyjs'
ELM = './node_modules/.bin/elm'


# Creates a Phony target
def PhonyTargets(
    target,
    action,
    depends,
    env=None,
):
    if not env:
        env = DefaultEnvironment()
    t = env.Alias(target, depends, action)
    env.AlwaysBuild(t)


env_options = {
    "ENV": os.environ,
}

scsssrc = Glob("scss/*.scss")
elmsrc = Glob("src/**/*.elm")
elmsrc += Glob("src/*.elm")

env = Environment(**env_options)

env.Command([ELM, UGLIFYJS], [], "npm install")

final = env.Alias("all", [MINJS, CSS])
env.Default(final)

env.Command(ELMJS, elmsrc + [ELM],
            f"{ELM} make src/Main.elm --optimize --output={ELMJS}")
env.Command(
    MINJS, [ELMJS, UGLIFYJS],
    f"{UGLIFYJS} {ELMJS} --compress 'pure_funcs=\"F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9\",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | {UGLIFYJS} --mangle --output={MINJS}"
)
env.Command(
    CSS, scsssrc,
    f"{SASS} scss/custom.scss:{CSS} --no-source-map --style compressed")

env.NoClean(ELM)
env.NoClean(UGLIFYJS)
