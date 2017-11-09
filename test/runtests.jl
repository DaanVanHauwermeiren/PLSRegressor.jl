using PLS
using Base.Test

# write your own tests here
reload("PLS")

PLS.check_constant_cols([1;1;1])

@testset "Auxiliary Functions Test" begin

    @testset "check constant columns" begin
	        try PLS.check_constant_cols([1 1; 2 1; 3.0 1]) catch @test true end
	end

	@testset "centralize" begin

		X        = reshape([1; 2; 3.0],(3,1))
		X        = PLS.centralize_data(X,mean(X,1),std(X,1))
		@test all(X .== [-1,0,1.0])

	end

	@testset "decentralize" begin

		Xo        = reshape([1; 2; 3.0],(3,1))
		Xn        = reshape([-1,0,1.0],(3,1))
		Xn = PLS.decentralize_data(Xn,mean(Xo,1),std(Xo,1))
		@test all(Xn .== [1; 2; 3.0])

	end

	@testset "checkdata" begin

         try PLS.check_params(2,1) catch @test true end
		 try PLS.check_params(-1,2) catch @test true end
		 @test PLS.check_params(1,2)

	end

	@testset "checkparams" begin

		 try PLS.check_data(Matrix{Float64}(0,0), 0) catch @test true end
		 try PLS.check_data(Matrix{Float64}(1,1), 10) catch @test true end
		 @test PLS.check_data(Matrix{Float64}(1,1), 1)

	end

end;


@testset "Pediction Tests" begin

	@testset "Single Column Prediction Test" begin

		X        = reshape([1; 2; 3.0],(3,1))
		Y        = [1; 2; 3.0]
		@time model = PLS.fit(X,Y,nfactors=1)
		pred = PLS.transform(model,X)
		@test isequal(round.(pred),[1; 2; 3.0])

	end


	@testset "Constant Values Prediction Tests" begin

		X        = [1 1;2 1;3 1.0]
		Y        = [1; 1; 1.0]
		@time model = PLS.fit(X,Y,nfactors=2)
		pred = PLS.transform(model,X)
		@test isequal(round.(pred),[1; 1; 1.0])

		X        = reshape([1; 1; 1.0],(3,1))
		Y        = [1; 1; 1.0]
		@time model = PLS.fit(X,Y,nfactors=1)
		pred = PLS.transform(model,X)
		@test isequal(round.(pred),[1; 1; 1.0])

	end

	@testset "Linear Prediction Tests" begin


		X        = [1 2; 2 4; 4.0 6]
		Y        = [2; 4; 6.0]
		@time model = PLS.fit(X,Y,nfactors=2)
		pred = PLS.transform(model,X)
		@test isequal(round.(pred),[2; 4; 6.0])

		X        = [1 -2; 2 -4; 4.0 -6]
		Y        = [-2; -4; -6.0]
		@time model = PLS.fit(X,Y,nfactors=2)
		pred = PLS.transform(model,X)
		@test isequal(round.(pred),[-2; -4; -6.0])

	end
end;
