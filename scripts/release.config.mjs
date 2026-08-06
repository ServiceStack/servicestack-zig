// Files that declare the version, kept in sync with package.json by `npm run bump`.
export const versionFiles = [
    {
        file: 'build.zig.zon',
        find: (v) => `.version = "${v}"`,
        replace: (v) => `.version = "${v}"`,
    },
]

// Zig packages are fetched by their release tarball, so its URL is versioned too
export const replacements = [
    {
        file: 'README.md',
        find: (v) => `archive/refs/tags/v${v}.tar.gz`,
        replace: (v) => `archive/refs/tags/v${v}.tar.gz`,
    },
]
