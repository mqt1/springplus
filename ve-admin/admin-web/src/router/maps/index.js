/*
 * @Author: 一日看尽长安花
 * @since: 2019-09-04 20:55:14
 * @LastEditTime: 2020-03-11 13:38:40
 * @LastEditors: 一日看尽长安花
 * @Description:
 */
/*
路由映射表，由路由名映射确定。
格式见最下方的注释
强制：name和path必须存在，且两者同时决定唯一性
 */
/*
前端路由映射表中单个路由映射全部具有的信息
  {
    "path": "/profile",
    "component": "Layout",
    "redirect": "/profile/index",
    "hidden": true,//非菜单路由需要设置
    "alwaysShow": true,//默认不设置
    "name": "router-name",
    "meta": {
      "noCache": true,//默认缓存
      "affix": true,
      "breadcrumb": false,
      "activeMenu": "/example/list"
    },
    "children": []
  }
后端路由表中单个路由应该具有的信息
  {
    "path": "/profile",
    "name": "router-name",
    "meta": {
      "title": "Profile",
      "roles": ["admin", "editor"],
      "icon": "user"
    },
    "children": []
  }
*/

/* Layout */
import Layout from '@/layout';

/* Router Map Modules */
import componentsRouter from './components';
import chartsRouter from './charts';
import tableRouter from './table';
import nestedRouter from './nested';
import coreRouter from './core';

/**
 * Note: sub-menu only appear when route children.length >= 1
 * Detail see: https://panjiachen.github.io/vue-element-admin-site/guide/essentials/router-and-nav.html
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    roles: ['admin','editor']    control the page roles (you can set multiple roles)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'             the icon show in the sidebar
    noCache: true                if set true, the page will no be cached(default is false)
    affix: true                  if set true, the tag will affix in the tags-view
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
 */

/**
 * asyncRoutes
 * the routes that need to be dynamically loaded based on user roles
 * 用来匹配后台生成的路由表，根据路由名称
 */
let asyncRoutes = [
  {
    path: '/permission',
    component: Layout,
    redirect: '/permission/page',
    alwaysShow: true, // will always show the root menu
    name: 'Permission',
    children: [
      {
        path: 'page',
        component: () => import('@/views/permission/page'),
        name: 'PagePermission'
      },
      {
        path: 'directive',
        component: () => import('@/views/permission/directive'),
        name: 'DirectivePermission'
      },
      {
        path: 'role',
        component: () => import('@/views/permission/role'),
        name: 'RolePermission'
      }
    ]
  },

  {
    path: '/icon',
    component: Layout,
    name: 'Icon',
    children: [
      {
        path: 'index',
        component: () => import('@/views/icons/index'),
        name: 'Icons',
        meta: { noCache: true }
      }
    ]
  },

  /** when your routing map is too long, you can split it into small modules **/
  componentsRouter,
  chartsRouter,
  nestedRouter,
  tableRouter,
  {
    path: '/example',
    component: Layout,
    redirect: '/example/list',
    name: 'Example',
    children: [
      {
        path: 'create',
        component: () => import('@/views/example/create'),
        name: 'CreateArticle'
      },
      {
        path: 'edit/:id(\\d+)',
        component: () => import('@/views/example/edit'),
        name: 'EditArticle',
        meta: { noCache: true, activeMenu: '/example/list' },
        hidden: true
      },
      {
        path: 'list',
        component: () => import('@/views/example/list'),
        name: 'ArticleList'
      }
    ]
  },

  {
    path: '/tab',
    name: 'Tab',
    component: Layout,
    children: [
      {
        path: 'index',
        component: () => import('@/views/tab/index'),
        name: 'Tabs'
      }
    ]
  },

  {
    path: '/error',
    component: Layout,
    redirect: 'noRedirect',
    name: 'ErrorPages',
    children: [
      {
        path: '401',
        component: () => import('@/views/error-page/401'),
        name: 'Page401',
        meta: { noCache: true }
      },
      {
        path: '404',
        component: () => import('@/views/error-page/404'),
        name: 'Page404',
        meta: { noCache: true }
      }
    ]
  },

  {
    path: '/error-log',
    name: 'ErrorLog',
    component: Layout,
    children: [
      {
        path: 'log',
        component: () => import('@/views/error-log/index'),
        name: 'ErrorLogs'
      }
    ]
  },

  {
    path: '/excel',
    component: Layout,
    redirect: '/excel/export-excel',
    name: 'Excel',
    children: [
      {
        path: 'export-excel',
        component: () => import('@/views/excel/export-excel'),
        name: 'ExportExcel'
      },
      {
        path: 'export-selected-excel',
        component: () => import('@/views/excel/select-excel'),
        name: 'SelectExcel'
      },
      {
        path: 'export-merge-header',
        component: () => import('@/views/excel/merge-header'),
        name: 'MergeHeader'
      },
      {
        path: 'upload-excel',
        component: () => import('@/views/excel/upload-excel'),
        name: 'UploadExcel'
      }
    ]
  },

  {
    path: '/zip',
    component: Layout,
    redirect: '/zip/download',
    alwaysShow: true,
    name: 'Zip',
    children: [
      {
        path: 'download',
        component: () => import('@/views/zip/index'),
        name: 'ExportZip'
      }
    ]
  },

  {
    path: '/pdf',
    name: 'PDF',
    component: Layout,
    redirect: '/pdf/index',
    children: [
      {
        path: 'index',
        component: () => import('@/views/pdf/index'),
        name: 'PDFS'
      }
    ]
  },
  {
    path: '/pdf/download',
    name: 'PdfDown',
    component: () => import('@/views/pdf/download'),
    hidden: true
  },

  {
    path: '/theme',
    name: 'Theme',
    component: Layout,
    children: [
      {
        path: 'index',
        component: () => import('@/views/theme/index'),
        name: 'Themes'
      }
    ]
  },

  {
    path: '/clipboard',
    name: 'Clipboard',
    component: Layout,
    children: [
      {
        path: 'index',
        component: () => import('@/views/clipboard/index'),
        name: 'ClipboardDemo'
      }
    ]
  },

  {
    path: 'external-link',
    name: 'ExternalLink',
    component: Layout,
    children: [
      {
        path: 'https://github.com/PanJiaChen/vue-element-admin',
        name: 'link'
      }
    ]
  },

  // 404 page must be placed at the end !!!
  { path: '*', redirect: '/404', hidden: true }
];

const asyncRoutesMap = [...coreRouter, ...asyncRoutes];

export default asyncRoutesMap;
