{
    echo "=== Current Working Dir ==="
    pwd
    echo -e "\n=== Searching for Nvim Config Folders ==="
    ls -la ~/.config/ | grep nvim
    
    echo -e "\n=== File Contents ==="
    find ~/.config/nvim* -type f 2>/dev/null | while read -r file; do
        echo "--------------------------------------------------------------------------------"
        echo "FILE: $file"
        echo "--------------------------------------------------------------------------------"
        cat "$file"
        echo -e "\n"
    done
} | pbcopy
