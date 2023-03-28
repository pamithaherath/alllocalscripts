$initiatingCircuitName = "erc-ninp-conn-pnp-erc-aue1"
$rg = "rg-ninp-conn-expressroute-pnp-aue1"
$circuitConnectionName = "cxn-vgw-npp-con-erc-aue-001"
$conRG = "rg-npp-con-networkhub-aue"

#Remove-AzVirtualNetworkGatewayConnection -Name $circuitConnectionName -ResourceGroupName $conRG -Force


#$circuit_init = Get-AzExpressRouteCircuit -Name $initiatingCircuitName -ResourceGroupName $rg

#Remove-AzExpressRouteCircuitConnectionConfig -Name $circuitConnectionName -ExpressRouteCircuit $circuit_init
#Set-AzExpressRouteCircuit -ExpressRouteCircuit $circuit_init

Remove-AzExpressRouteCircuit -Name $initiatingCircuitName -ResourceGroupName $rg -Force