//targetScope  = 'subscription'


param MGT2aueventname string = 'vnet-prd-mgt-aue-001'

param auelocation string = resourceGroup().location



resource rt_prd_aue_mgt_ra_win 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-ra-win'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-ra-win'
        properties: {
         addressPrefix: '10.97.8.0/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}
  
resource rt_prd_aue_mgt_ra_lin 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-ra-lin'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-ra-lin'
        properties: {
         addressPrefix: '10.97.8.32/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}
resource rt_prd_aue_mgt_smtp 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-smtp'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-smtp'
        properties: {
         addressPrefix: '10.97.8.64/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_vulnscan 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-vulnscan'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-vulnscan'
        properties: {
         addressPrefix: '10.97.8.96/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_devops 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-devops'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-devops'
        properties: {
         addressPrefix: '10.97.8.128/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_siemdev 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-siendev'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-siemdev'
        properties: {
         addressPrefix: '10.97.8.160/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_siemsit 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-siemsit'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-siemsit'
        properties: {
         addressPrefix: '10.97.8.192/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_symep_win 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-symep-win'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-symep-win'
        properties: {
         addressPrefix: '10.97.8.160/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_clmep_lin 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-clmep-lin'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-clmep-lin'
        properties: {
         addressPrefix: '10.97.9.0/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_whlist 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-whlist'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-whlist'
        properties: {
         addressPrefix: '10.97.9.32/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_midserver 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-midserver'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-midserver'
        properties: {
         addressPrefix: '10.97.9.64/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}


resource rt_prd_aue_mgt_tenable 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-tenable'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-tenable'
        properties: {
         addressPrefix: '10.97.9.96/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_oem 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-oem'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-oem'
        properties: {
         addressPrefix: '10.97.9.128/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_cyberark 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-cyberark'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-cyberark'
        properties: {
         addressPrefix: '10.97.9.160/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_pvtep 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-pvtep'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-pvtep'
        properties: {
         addressPrefix: '10.97.9.192/27'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_stopvt 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-stopvt'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-stopvt'
        properties: {
         addressPrefix: '10.97.16.0/26'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}

resource rt_prd_aue_mgt_anf 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-prd-aue-mgt-anf'
  location: auelocation
  properties: {
   
    routes: [
      {
        name: 'route-to-prd-aue-mgt-anf'
        properties: {
         addressPrefix: '10.97.16.64/26'
         hasBgpOverride: false
         nextHopType: 'VnetLocal'
        }
      }
      
    ]
  }
}


//Network Security Groups

resource nsg_prd_aue_mgt_ra_win 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-ra-win'
  location: auelocation
}

resource nsg_prd_aue_mgt_ra_lin 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-ra-lin'
  location: auelocation
}
resource nsg_prd_aue_mgt_smtp 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-smtp'
  location: auelocation
}

resource nsg_prd_aue_mgt_vulnscan 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-vulnscan'
  location: auelocation
}

resource nsg_prd_aue_mgt_devops 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-devops'
  location: auelocation
}

resource nsg_prd_aue_mgt_siemdev 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-siemdev'
  location: auelocation
}

resource nsg_prd_aue_mgt_siemsit 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-siemsit'
  location: auelocation
}

resource nsg_prd_aue_mgt_symep_win 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-symep-win'
  location: auelocation
}

resource nsg_prd_aue_mgt_clmep_lin 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-clmep-lin'
  location: auelocation
}

resource nsg_prd_aue_mgt_whlist 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-whlist'
  location: auelocation
}

resource nsg_prd_aue_mgt_midserver'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-midserver'
  location: auelocation
}

resource nsg_prd_aue_mgt_tenable'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-tenable'
  location: auelocation
}

resource nsg_prd_aue_mgt_oem'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-oem'
  location: auelocation
}

resource nsg_prd_aue_mgt_cyberark'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-cyberark'
  location: auelocation
}

resource nsg_prd_aue_mgt_pvtep'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-pvtep'
  location: auelocation
}

resource nsg_prd_aue_mgt_stopvt'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-stopvt'
  location: auelocation
}

resource nsg_prd_aue_mgt_anf'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-prd-aue-mgt-anf'
  location: auelocation
}



resource MGTaueventname_ 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: MGT2aueventname
  location: auelocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.97.8.0/21'
      ]
    }
    subnets: [
      {
        name: 'sn-prd-aue-mgt-ra-win'
        properties: {
          addressPrefix: '10.97.8.0/27'

          routeTable: {
            id: rt_prd_aue_mgt_ra_win.id
          }
          networkSecurityGroup: {
            id: nsg_prd_aue_mgt_ra_win.id

          }
        }
      }
      {
        name: 'sn-prd-aue-mgt-ra-lin'
        properties: {
          addressPrefix:  '10.97.8.32/27'

          routeTable: {
            id: rt_prd_aue_mgt_ra_lin.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_ra_lin.id

          }
        }
      }
      {
        name: 'sn-prd-aue-mgt-smtp'
        properties: {
          addressPrefix: '10.97.8.64/27'
          routeTable: {
           id: rt_prd_aue_mgt_smtp.id
          }
          networkSecurityGroup: {
          id: nsg_prd_aue_mgt_smtp.id

          }
        }
      }
      {
        name: 'sn-prd-aue-mgt-vulnscan'
        properties: {
          addressPrefix: '10.97.8.96/27'
          routeTable: {
          id: rt_prd_aue_mgt_vulnscan.id
          }
          networkSecurityGroup: {
          id: nsg_prd_aue_mgt_vulnscan.id

          }
        }
      }
      {
        name: 'sn-prd-aue-mgt-devops'
        properties: {
          addressPrefix: '10.97.8.128/27'

          routeTable: {
           id: rt_prd_aue_mgt_devops.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_devops.id

          }
        }
      }
      {
        name: 'sn-prd-aue-mgt-siemdev'
        properties: {
          addressPrefix: '10.97.8.160/27'
          routeTable: {
           id: rt_prd_aue_mgt_siemdev.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_siemdev.id

          }
        }
      }
      {
        name: 'sn-prd-aue-mgt-siemsit'
        properties: {
          addressPrefix: '10.97.8.192/27'
          routeTable: {
           id: rt_prd_aue_mgt_siemsit.id
          }
          networkSecurityGroup: {
            id: nsg_prd_aue_mgt_siemsit.id

          }
        }
      }
      {
        name: 'sn-prd-aue-mgt-symep-win'
        properties: {
          addressPrefix: '10.97.8.224/27'
          routeTable: {
          id: rt_prd_aue_mgt_symep_win.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_symep_win.id

          }
        }
      }

      {
        name: 'sn-prd-aue-mgt-clmep-lin'
        properties: {
          addressPrefix: '10.97.9.0/27'
          routeTable: {
          id: rt_prd_aue_mgt_clmep_lin.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_clmep_lin.id

          }
        }
      }

      {
        name: 'sn-prd-aue-mgt-whlist'
        properties: {
          addressPrefix: '10.97.9.32/27'
          routeTable: {
          id: rt_prd_aue_mgt_whlist.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_whlist.id

          }
        }
      }

      {
        name: 'sn-prd-aue-mgt-midserver'
        properties: {
          addressPrefix: '10.97.9.64/27'
          routeTable: {
          id: rt_prd_aue_mgt_midserver.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_midserver.id

          }
        }
      }

      {
        name: 'sn-prd-aue-mgt-tenable'
        properties: {
          addressPrefix: '10.97.9.96/27'
          routeTable: {
          id: rt_prd_aue_mgt_tenable.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_tenable.id

          }
        }
      }

      {
        name: 'sn-prd-aue-mgt-oem'
        properties: {
          addressPrefix: '10.97.9.128/27'
          routeTable: {
          id: rt_prd_aue_mgt_oem.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_oem.id

          }
        }
      }

      {
        name: 'sn-prd-aue-mgt-cyberark'
        properties: {
          addressPrefix: '10.97.9.160/27'
          routeTable: {
          id: rt_prd_aue_mgt_cyberark.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_cyberark.id

          }
        }
      }

      {
        name: 'sn-prd-aue-mgt-pvtep'
        properties: {
          addressPrefix: '10.97.9.192/27'
          routeTable: {
          id: rt_prd_aue_mgt_pvtep.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_pvtep.id

          }
        }
      }
    ]
  }
}

resource MGTVNET2 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: MGT2aueventname
  location: auelocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.97.16.0/21'
      ]
    }
    subnets: [
      {
        name: 'sn-prd-aue-mgt-stopvt'
        properties: {
          addressPrefix: '10.97.16.0/26'
          routeTable: {
          id: rt_prd_aue_mgt_stopvt.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_stopvt.id

          }
        }
      }

      {
        name: 'sn-prd-aue-mgt-anf'
        properties: {
          addressPrefix: '10.97.16.64/26'
          routeTable: {
          id: rt_prd_aue_mgt_anf.id
          }
          networkSecurityGroup: {
           id: nsg_prd_aue_mgt_anf.id

          }
        }
      }
    ]
  }

}


