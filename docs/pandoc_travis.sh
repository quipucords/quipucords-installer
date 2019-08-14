curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C ~/.local/bin '*/stack'
stack --version
git clone --depth=50 https://github.com/jgm/pandoc
cd pandoc
echo "allow-newer: true" >> stack.yaml
stack setup
travis_wait stack install --ghc-options="-O2" pandoc pandoc-citeproc || true
ls -lh ~/.local/bin
pandoc --version || true
pandoc-citeproc --version || true
