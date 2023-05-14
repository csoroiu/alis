### some links on AF_UNIX & WSL

https://stackoverflow.com/questions/73067135/af-unix-socket-in-linux-above-windows-wsl-fails-to-bind-to-mnt-file-error-95
https://github.com/microsoft/WSL/issues/5961https://devblogs.microsoft.com/commandline/af_unix-comes-to-windows/
https://devblogs.microsoft.com/commandline/windowswsl-interop-with-af_unix/

### Docker completion
Run:
```shell
mkdir -p ~/.docker
docker completion bash >~/.docker/docker.completion.bash.inc
```
Inside `~/.bashrc` add:
```shell
source $HOME/.docker/docker.completion.bash.inc
#Enable `d' alias and completion for it
alias d=docker
complete -F __start_docker d
```
