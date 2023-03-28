
Remove-AzVirtualNetworkGatewayConnection -Name "cxn-prd-con-erc-ase-001" -ResourceGroupName "rg-prd-con-expressroute-ase" -Force
Remove-AzVirtualNetworkGatewayConnection -Name "cxn-prd-con-vpn-ase-001" -ResourceGroupName "rg-prd-con-networkhub-ase"
Remove-AzVirtualNetworkGatewayConnection -Name "cxn-prd-con-vpn-aue-001" -ResourceGroupName "rg-prd-con-networkhub-aue" -Force
Remove-AzVirtualNetworkGateway -Name "ercg-prd-con-ase-001" -ResourceGroupName "rg-prd-con-networkhub-ase" -Force
Remove-AzVirtualNetworkGateway -Name "ercg-prd-con-aue-001" -ResourceGroupName "rg-prd-con-networkhub-aue" -Force
Remove-AzVirtualNetworkGateway -Name "vpng-prd-con-aue-001" -ResourceGroupName "rg-prd-con-networkhub-aue" -Force
Remove-AzVirtualNetworkGateway -Name "vpng-prd-con-ase-001" -ResourceGroupName "rg-prd-con-networkhub-ase" -Force
Remove-AzVirtualNetworkGateway -Name "vgw-prd-con-vpn-auc1" -ResourceGroupName "rg-prd-con-networkhub-auc1" -Force
Remove-AzLocalNetworkGateway -Name "lng-prd-con-vpn-ase-001" -ResourceGroupName "rg-prd-con-expressroute-ase" -Force
Remove-AzLocalNetworkGateway -Name "lng-prd-con-vpn-ase-002" -ResourceGroupName "rg-prd-con-expressroute-ase" -Force
Remove-AzLocalNetworkGateway -Name "lng-prd-con-vpn-aue-001" -ResourceGroupName "rg-prd-con-expressroute-aue" -Force
Remove-AzLocalNetworkGateway -Name "lng-prd-con-vpn-aue-002" -ResourceGroupName "rg-prd-con-expressroute-aue" -Force

