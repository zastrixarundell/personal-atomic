if status is-interactive
    abbr -a setup_elixir distrobox assemble create --file /etc/distrobox/initfiles.d/elixir-dev.ini
    abbr -a setup_phoenix mix hex.archive install phx_new
    abbr -a setup_brew '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    abbr -a setup_postgres podman run -it -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d --name postgres_development postgres
end

