module.exports = {
  title: 'DevSpace Cloud | Documentation',
  tagline: 'The tagline of my site',
  url: 'https://devspace.cloud',
  baseUrl: '/',
  favicon: '/img/docs/cloud/favicon.png',
  organizationName: 'devspace-cloud', // Usually your GitHub org/user name.
  projectName: 'devspace-cloud', // Usually your repo name.
  themeConfig: {
    disableDarkMode: true,
    navbar: {
      logo: {
        alt: 'DevSpace Cloud',
        src: '/img/docs/cloud/logo-devspace-cloud.svg',
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
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Style Guide',
              to: 'pages/introduction',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/docusaurus',
            },
            {
              label: 'Discord',
              href: 'https://discordapp.com/invite/docusaurus',
            },
          ],
        },
        {
          title: 'Social',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/facebook/docusaurus',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/docusaurus',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} DevSpace Technologies Inc.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          path: 'pages',
          routeBasePath: 'docs/cloud',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl:
            'https://github.com/devspace-cloud/devspace-cloud/edit/master/pages/',
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
