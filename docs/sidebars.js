/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

module.exports = {
  adminSidebar: [
    {
      type: 'doc',
      id: 'introduction',
    },
    {
      type: 'category',
      label: 'Getting Started',
      items: [
        'admin/getting-started/setup',
        'admin/getting-started/connect-clusters',
        'admin/getting-started/create-spaces',
        'admin/getting-started/cluster-users',
        'admin/getting-started/space-limits',
      ],
    },
    {
      type: 'category',
      label: 'Spaces',
      items: [
        'admin/spaces/basics',
        {
          type: 'category',
          label: 'Space Limits & Isolation',
          items: [
            'admin/spaces/limits-isolation/basics',
            'admin/spaces/limits-isolation/namespace-limits',
            'admin/spaces/limits-isolation/container-limits',
            'admin/spaces/limits-isolation/network-limits',
            'admin/spaces/limits-isolation/sleep-mode',
            'admin/spaces/limits-isolation/templates',
            'admin/spaces/limits-isolation/gatekeeper-rules',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Clusters',
      items: [
        'admin/clusters/basics',
        'admin/clusters/control-plane',
        'admin/clusters/users-invites',
        'admin/clusters/space-limits',
        'admin/clusters/encryption-keys',
      ],
    },
    {
      type: 'doc',
      id: 'admin/image-registry',
    },
    {
      type: 'category',
      label: 'Teams',
      items: [
        'admin/teams/basics',
        'admin/teams/members-invites',
        'admin/teams/clusters',
        'admin/teams/image-registry',
        'admin/teams/variables',
      ],
    },
    {
      type: 'category',
      label: 'On-Premise Edition',
      items: [
        'admin/on-premise/editions',
        'admin/on-premise/installation',
        'admin/on-premise/upgrades',
        'admin/on-premise/license-keys',
        'admin/on-premise/users',
        'admin/on-premise/spaces',
        'admin/on-premise/clusters',
        'admin/on-premise/teams',
      ],
    },
    {
      type: 'link',
      label: '↗️ DevSpace CLI',
      href: 'https://devspace.sh/cli/docs/introduction',
    },
  ],
};
