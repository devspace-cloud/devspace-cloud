__webpack_public_path__ = "/cloud/"

module.exports = {
  title: 'DevSpace Cloud | Documentation',
  tagline: 'The tagline of my site',
  url: 'https://devspace.cloud',
  baseUrl: __webpack_public_path__,
  favicon: '/img/favicon.png',
  organizationName: 'devspace-cloud', // Usually your GitHub org/user name.
  projectName: 'devspace-cloud', // Usually your repo name.
  themeConfig: {
    disableDarkMode: true,
    navbar: {
      logo: {
        alt: 'DevSpace Cloud',
        src: '/img/logo-devspace-cloud.svg',
        href: '/',
      },
      links: [
        {to: 'docs/introduction', label: 'Docs', position: 'left'},
        {href: '/blog', label: 'Blog', position: 'left'},
        {
          href: 'https://github.com/devspace-cloud/devspace-cloud',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    algolia: {
      apiKey: "4339e8c4d6313d53209b996a35e7c0d5",
      indexName: "devspace",
      placeholder: "Search...",
      algoliaOptions: {}
    },
    footer: {
      style: 'light',
      links: [],
      copyright: `Copyright © ${new Date().getFullYear()} DevSpace Technologies Inc.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          path: 'pages',
          routeBasePath: 'docs',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl:
            'https://github.com/devspace-cloud/devspace-cloud/edit/master/docs/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
  scripts: [
    {
      src:
        'https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.0/clipboard.min.js',
      async: true,
    },
  ],
};
