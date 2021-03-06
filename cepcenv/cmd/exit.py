import click

from cepcenv.env import Env

class Exit(object):
    def execute(self, config, shell):
        script = ''

        env = Env()
        env.clean()
        setenv, unset = env.final_all_env()

        for e in unset:
            script += shell.unset_env(e)
        for k, v in setenv.items():
            script += shell.set_env(k, v)

        script += shell.undefine_cepcenv()

        click.echo(script, nl=False)
